import { STSClient, AssumeRoleCommand } from '@aws-sdk/client-sts';
import { getConfinfoAssumeRoleArn, getConfinfoLambdaRegion } from './config.js'

const roleArn = getConfinfoAssumeRoleArn();
const lambdaRegion = getConfinfoLambdaRegion();

/**
 * Gets temporary security credentials by assuming DiagnosticAssumeRole IAM
 * role.
 *
 * @return {Promise<Object>} Temporary security credentials: Access Key ID,
 * Secret Access Key and Session Token
 */
export const getAssumeRoleCredentials = async () => {
  const stsClient = new STSClient({ region: lambdaRegion });
  const assumeRoleCommand = new AssumeRoleCommand({
    RoleArn: roleArn,
    RoleSessionName: 'ListDiagnosticFunctions',
  });

  const { Credentials } = await stsClient.send(assumeRoleCommand);
  return {
    accessKeyId: Credentials.AccessKeyId,
    secretAccessKey: Credentials.SecretAccessKey,
    sessionToken: Credentials.SessionToken,
  };
};