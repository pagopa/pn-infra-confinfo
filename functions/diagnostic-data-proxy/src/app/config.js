/**
 * Retrieves the value of an environment variable.
 *
 * @param {string} env - The name of the environment variable to retrieve.
 * @return {string} The value of the specified environment variable.
 * @throws {Error} When the environment variable is not defined.
 */
const getEnvironmentVariable = (env) => {
  const value = process.env[env];
  if (!value) {
    throw new Error(`Environment variable "${env}" is not defined.`);
  }
  return value;
};

/**
 * Gets the safestorage bucket name from environment variables.
 *
 * @return {string} The storage bucket name.
 */
export const getSafeStorageBucket = () =>
  getEnvironmentVariable('SAFESTORAGE_BUCKET');

/**
 * Get the AWS region for DynamoDB from environment variables.
 *
 * @return {string} The AWS region for DynamoDB.
 */
export const getDynamoAWSRegion = () =>
  getEnvironmentVariable('DYNAMO_AWS_REGION');

/**
 * Gets the AWS region for S3 services from environment variables.
 *
 * @return {string} The AWS region for S3.
 */
export const getS3AWSRegion = () => getEnvironmentVariable('S3_AWS_REGION');

/**
* Gets the generated url expiration in seconds.
*
* @return {number} The url expiration in seconds, undefined otherwise.
*/
export const getUrlExpiresSeconds = () => {
  try{
    return parseInt(getEnvironmentVariable('URL_EXPIRES_SECONDS'));
  } catch (e){
    return undefined;
  }
};
