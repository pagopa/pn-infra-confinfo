import { getObject, headObject, restoreObject } from './safestorage.js';
import { getEvents } from './ecRichiesteMetadati.js';
import {
  checkKeys,
  makeResponse,
  makeErrorResponse,
  createCustomError,
} from './utils.js';

const InvalidActionError = createCustomError('InvalidActionError', 501);

/**
 * Handles an event by executing different actions based on the event's details.
 *
 * @param {Object} event - The event to handle, containing an action and a
 * payload.
 * @return {Promise<Object>} A promise that resolves to an object with a
 * statusCode and a body. The body contains the result of the action, if
 * successful.
 */
export const handleEvent = async (event) => {
  try {
    checkKeys(event, [['action', 'string']]);
    switch (event.action) {
      case 'RESTORE_OBJECT': {
        const { fileKey } = checkKeys(event, [['fileKey', 'string']])
        return makeResponse(200, await restoreObject(fileKey));
      }
      case 'GET_OBJECT': {
        const { fileKey } = checkKeys(event, [['fileKey', 'string']])
        return makeResponse(200, await getObject(fileKey));
      }
      case 'HEAD_OBJECT': {
        const { fileKey } = checkKeys(event, [['fileKey', 'string']])
        let res = await headObject(fileKey);
        return makeResponse(res.found ? 200 : 404, res);
      }
      case 'GET_EC_RICHIESTE_METADATI': {
        const { requestId } = checkKeys(event, [['requestId', 'string']]);
        const { checkRetry = false } = event;
        let res = await getEvents(requestId, checkRetry);
        return makeResponse(200, res);
      }
    }
    throw new InvalidActionError();
  } catch (e) {
    return makeErrorResponse(e);
  }
};
