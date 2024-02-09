import { getObject, headObject } from './safestorage.js';
import { getEvents } from './ecRichiesteMetadati.js';
import { checkKeys, makeResponse } from './utils.js';

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
  } catch (e) {
    return makeResponse(400, `Invalid request: ${e.message}`);
  }

  switch (event.action) {
    case 'GET_OBJECT':
    case 'HEAD_OBJECT':
      try {
        const { fileKey } = checkKeys(event, [['fileKey', 'string']]);
        let res =
          event.action === 'HEAD_OBJECT'
            ? await headObject(fileKey)
            : await getObject(fileKey);
        return makeResponse(res.found ? 200 : 404, res);
      } catch (e) {
        return makeResponse(400, e.message);
      }
    case 'GET_EC_RICHIESTE_METADATI':
      try {
        const { requestId } = checkKeys(event, [['requestId', 'string']]);
        const { checkRetry = false } = event;
        let res = await getEvents(requestId, checkRetry);
        return makeResponse(200, res);
      } catch (e) {
        return makeResponse(400, e.message);
      }
  }
  return makeResponse(501, `Invalid action!`);
};
