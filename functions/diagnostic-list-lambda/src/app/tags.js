import {
  GetResourcesCommand,
  ResourceGroupsTaggingAPIClient,
} from '@aws-sdk/client-resource-groups-tagging-api';
import { getCurrentAccount, getCurrentRegion } from './config.js';

const FUNCTION_TYPE_KEY = 'FunctionType';
const FUNCTION_DESCRIPTION_KEY = 'FunctionDescription';
const FUNCTION_CATEGORY_KEY = 'FunctionCategory';

const tagClient = new ResourceGroupsTaggingAPIClient({ region: getCurrentRegion() });

/**
 * Fetches all Lambda functions from the AWS account that are tagged with a
 * specific 'FUNCTION_TYPE_KEY' and returns an array of objects. Each object
 * contains the Lambda function's name, an optional description, an optional
 * category, the function type and the account name.
 *
 * @param {string} typeValue - The value of the 'FUNCTION_TYPE_KEY' tag used to
 * filter the Lambda functions.
 * @throws {Error} If the current account value is not 'core' or 'confinfo',
 * indicating the function is restricted to specific account types due to its
 * operational scope.
 * @return {Promise<Array<{name: string, description: string | undefined,
*  category: string | undefined, type: string, account: string}>>} A promise that resolves to
*  an array of objects representing the Lambda functions. Each function's
*  details include its name, and optionally, its description and category, its
*  type, along with the account name.
*/
export const getAllFunctions = async (functionType) => {
  const account = getCurrentAccount().toLowerCase();
  if (account !== 'core' && account !== 'confinfo') {
    throw new Error('Current account value not in [core, confinfo].');
  }

  // Send a command to get resources filtered by Lambda function type
  let resources = await tagClient.send(
    new GetResourcesCommand({
      ResourceTypeFilters: ['lambda:function'],
      TagFilters: [{ Key: FUNCTION_TYPE_KEY, Values: [functionType] }],
    }),
  );

  // Map the resource tag mappings to a simplified object structure.
  const functions = resources.ResourceTagMappingList.map((res) => {
    const nameParts = res.ResourceARN.split(':');
    const name = nameParts[nameParts.length - 1];
    let description = undefined;
    let category = undefined;
    let type = undefined;
    // Extract description and category from tags.
    for (const tag of res.Tags) {
      switch (tag.Key) {
        case FUNCTION_TYPE_KEY:
          type = tag.Value;
          break;
        case FUNCTION_DESCRIPTION_KEY:
          description = tag.Value;
          break;
        case FUNCTION_CATEGORY_KEY:
          category = tag.Value;
          break;
      }
    }
    return {
      name,
      description,
      category,
      account,
      type
    };
  });

  return functions;
};
