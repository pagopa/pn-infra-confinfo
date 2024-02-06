import { getObject, headObject } from "./safestorage.js";
import { getEvents } from "./ecRichiesteMetadati.js";

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
