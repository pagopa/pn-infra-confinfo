/**
 * Retrieves the value of an environment variable.
 *
 * @param {string} env - The name of the environment variable to retrieve.
 * @return {string} The value of the specified environment variable.
 */
const getEnvironmentVariable = (env) => process.env[env];

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
  const value = parseInt(getEnvironmentVariable('URL_EXPIRES_SECONDS'));
  if (isNaN(value)) {
    return undefined;
  }
  return value;
};

/**
 * Retrieves the number of days for which a Glacier restored object will remain
 * in the S3 Standard storage class before being moved back to Glacier.
 *
 * @returns {number | undefined} The number of days to keep the restored object
 * in S3 Standard storage class as an integer, `undefined` otherwise.
 */
export const getGlacierRestoreDays = () => {
  const value = parseInt(getEnvironmentVariable('GLACIER_RESTORE_DAYS'));
  if (isNaN(value)) {
    return undefined;
  }
  return value;
};


/**
 * Retrieves the tier to use for a Glacier restore job. The value is determined
 * by an environment variable. Valid tiers include 'Standard', 'Bulk', and
 * 'Expedited'. The choice of tier affects the cost and speed of the restore
 * operation.
 *
 * @returns {string} The Glacier restore tier, one of 'Standard', 'Bulk', or
 * 'Expedited'.
 */
export const getGlacierRestoreTier = () =>
  getEnvironmentVariable('GLACIER_RESTORE_TIER');
