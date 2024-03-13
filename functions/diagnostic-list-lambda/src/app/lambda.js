import { getConfinfoLambdaName, getConfinfoLambdaRegion } from './config.js'
import { getAssumeRoleCredentials } from './sts.js'
import { LambdaClient, InvokeCommand } from '@aws-sdk/client-lambda'

const lambdaRegion = getConfinfoLambdaRegion();
const confinfoListFunctionsName = getConfinfoLambdaName();

/**
 * Invoke a Lambda function with a specified function name and payload.
 *
 * @param {string} funcName - Lambda function name.
 * @param {string} payload - Payload.
 * @return {Promise<Object>} The Lambda response.
 */
const invoke = async (funcName, payload = {}) => {
  const credentials = await getAssumeRoleCredentials();
  const client = new LambdaClient({
    region: lambdaRegion,
    credentials,
  });

  const command = new InvokeCommand({
    FunctionName: funcName,
    Payload: JSON.stringify(payload),
  });

  const { Payload } = await client.send(command);
  const parsedPayload = JSON.parse(Buffer.from(Payload).toString());
  parsedPayload.body = JSON.parse(parsedPayload.body);
  return parsedPayload;
};

/**
 * Fetches all confinfo diagnostic functions by invoking the Lambda function.
 *
 * @returns {Promise<Object>} The list of all confinfo diagnostic functions.
 */
export const getConfinfoAllFunctions = async (functionType) => {
  return await invoke(confinfoListFunctionsName, { functionType });
};
