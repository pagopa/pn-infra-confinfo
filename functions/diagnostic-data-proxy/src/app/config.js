const getEnvVariable = (env) => {
  const value = process.env[env];
  if (!value) {
    throw new Error(`Env var ${env} is not defined.`);
  }
  return value;
};

export const getSafeStorageBucket = () => getEnvVariable("SAFESTORAGE_BUCKET");
export const getDynamoAWSRegion = () => getEnvVariable("DYNAMO_AWS_REGION");
export const getS3AWSRegion = () => getEnvVariable("S3_AWS_REGION");