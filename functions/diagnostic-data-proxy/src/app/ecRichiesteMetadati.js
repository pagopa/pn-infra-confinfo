import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, GetCommand } from '@aws-sdk/lib-dynamodb';
import { getDynamoAWSRegion } from './config.js';

const client = new DynamoDBClient({ region: getDynamoAWSRegion() });
const dynamo = DynamoDBDocumentClient.from(client);
const tableName = 'pn-EcRichiesteMetadati';

/**
 * Fetches an event by its requestId from DynamoDB.
 * 
 * @param {string} requestId - The unique identifier for the request.
 * @return {Promise<Object>} The event data associated with the requestId, if found.
 */
export const getEvent = async (requestId) => {
  const command = new GetCommand({
    TableName: tableName,
    Key: {
      requestId: requestId,
    },
  });
  return (await dynamo.send(command)).Item;
};


/**
  * Retrieves events from DynamoDB based on a requestId. If `checkRetry` is enabled,
  * it attempts to fetch additional events by appending a .PCRETRY_0, .PCRETRY_1 etc.
  *
  * @param {string} requestId - The base requestId for the event(s) to fetch.
  * @param {boolean} checkRetry - A flag to determine whether to perform retries. If true,
  *                                the function will attempt to fetch events with .PCRETRY_i.
  * @return {Promise<Array>} A promise that resolves to an array of events related to the requestId.
  *                          If no events are found it returns an empty array.
  */
export const getEvents = async (requestId, checkRetry) => {
  let requestIdRetry = requestId;
  let iRetry = 0;
  const out = [];
  let res;
  do {
    if (checkRetry) {
      requestIdRetry = requestId + '.PCRETRY_' + iRetry++;
    }
    console.log('GET:', requestIdRetry);
    res = await getEvent(requestIdRetry);
    if (res) {
      out.push(res);
    }
  } while (res && checkRetry);
  return out;
};
