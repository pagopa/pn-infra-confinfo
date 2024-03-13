/**
 * Retrieves the value of an environment variable.
 *
 * @param {string} env - The name of the environment variable to retrieve.
 * @param {string} [defaultValue] - The default value to return if the
 * environment variable is not defined.
 * @return {string} The value of the specified environment variable or the
 * default value if not defined.
 */
const getEnvironmentVariable = (env, defaultValue = '') => {
  const value = process.env[env];
  if (!value) {
    if (defaultValue !== '') {
      return defaultValue;
    }
    throw new Error(`Environment variable ${env} is not defined.`);
  }
  return value;
};

/**
 * Gets the role to assume in confinfo.
 *
 * @return {string} The role arn.
 */
export const getConfinfoAssumeRoleArn = () =>
  getEnvironmentVariable('CONFINFO_ASSUME_ROLE_ARN');

/**
 * Get the AWS region for confinfo Lambda.
 *
 * @return {string} The AWS region for confinfo Lambda.
 */
export const getConfinfoLambdaRegion = () =>
  getEnvironmentVariable('CONFINFO_LAMBDA_REGION', 'eu-south-1');

/**
 * Get the confinfo ListFunctions Lambda name.
 *
 * @return {string} The confinfo ListFunctions Lambda name.
 */
export const getConfinfoLambdaName = () =>
  getEnvironmentVariable('CONFINFO_LAMBDA_NAME');

/**
 * Get the current account [core, confinfo].
 *
 * @return {string} The current account.
 */
export const getCurrentAccount = () =>
  getEnvironmentVariable('CURRENT_ACCOUNT');

/**
 * Get the current region.
 *
 * @return {string} The current region.
 */
export const getCurrentRegion = () =>
  getEnvironmentVariable('CURRENT_REGION', 'eu-south-1');