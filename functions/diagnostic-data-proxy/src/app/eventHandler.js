import { getObject, headObject } from "./safestorage.js";
import { getEvents } from "./ecRichiesteMetadati.js";

/**
 * Handles an event by executing different actions based on the event's details.
 *
 * @param {Object} event - The event to handle, containing an action and a payload.
 * @return {Promise<Object>} A promise that resolves to an object with a statusCode and a body.
 *                           The body contains the result of the action, if successful.
 */
export const handleEvent = async (event) => {
  const { action, payload } = event;
  
  if( action === "GET_OBJECT") {
    try {
      let body = await getObject(payload.aarKey);
      return {
        statusCode: 200,
        body
      };
    } catch (err) {
      return {
        statusCode: 400,
      };
    }
  }else if( action === "HEAD_OBJECT") {
    let body = await headObject(payload.aarKey);
    return {
      statusCode: (body.found) ? 200 : 404,
      body
    };
  } else if( action === "GET_EC_RICHIESTE_METADATI") {
    const checkRetry = payload.checkRetry === undefined ? 
                                  false : payload.checkRetry;
    let body = await getEvents(payload.requestId, checkRetry);
    return {
      statusCode: 200,
      body
    };
  }
  return {
    statusCode: 200,
    body: 'I am alive!',
  };
};
