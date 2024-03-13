import { getCurrentAccount } from './config.js';
import { getAllFunctions } from './tags.js';
import { getConfinfoAllFunctions } from './lambda.js';
import { makeResponse } from './utils.js';

/**
 * It fetches all diagnostic functions for the current account and, if the
 * account is 'core', it also includes diagnostic functions from 'confinfo'.
 *
 * @param {Object} event - The event object that triggered the function.
 * @returns {Promise<{statusCode: number, body: string}>} An object containing
 * the HTTP status code and a stringified JSON body.
 */
export const handleEvent = async (event) => {
  try {
    const account = getCurrentAccount().toLowerCase();
    if (account !== 'core' && account !== 'confinfo') {
      return makeResponse(500, 'Current account value not in [core, confinfo]');
    }
    let allFunctions = await getAllFunctions(event.functionType);
    if (account === 'core') {
      const confinfoFunctions = await getConfinfoAllFunctions(event.functionType);
      allFunctions = [
        ...allFunctions,
        ...confinfoFunctions.body.functions,
      ];
    }
    return makeResponse(200, {
      functions: allFunctions,
    });
  } catch (e) {
    return makeResponse(400, `Invalid request: ${e.message}`);
  }
};
