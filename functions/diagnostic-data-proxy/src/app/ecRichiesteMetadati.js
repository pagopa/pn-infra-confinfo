import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, GetCommand } from '@aws-sdk/lib-dynamodb';
import { getDynamoAWSRegion } from './config.js';

const client = new DynamoDBClient({ region: getDynamoAWSRegion() });
const dynamo = DynamoDBDocumentClient.from(client);
const tableName = 'pn-EcRichiesteMetadati';

export const getEvent = async (requestId) => {
  const command = new GetCommand({
    TableName: tableName,
    Key: {
      requestId: requestId,
    },
  });
  return (await dynamo.send(command)).Item;
};

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
