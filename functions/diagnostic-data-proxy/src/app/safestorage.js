import {
  GetObjectCommand,
  GetObjectTaggingCommand,
  GetObjectRetentionCommand,
  HeadObjectCommand,
  RestoreObjectCommand,
  S3Client,
} from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { getSafeStorageBucket, getS3AWSRegion, getUrlExpiresSeconds } from './config.js';

const DEFAULT_EXPIRATION_SECONDS = 60 * 5; // 5 minutes default

const urlExpiresInSeconds = getUrlExpiresSeconds() ?? DEFAULT_EXPIRATION_SECONDS;

const client = new S3Client({ region: getS3AWSRegion() });
const bucket = getSafeStorageBucket();

/**
 * Initiates the restoration of an object from S3 Glacier storage.
 *
 * @param {string} bucket - The name of the S3 bucket containing the object.
 * @param {string} key - The key of the object to restore.
 */
const restoreObject = async (bucket, key) => {
  const input = {
    Bucket: bucket,
    Key: key,
    RestoreRequest: {
      Days: 5,
      GlacierJobParameters: {
        Tier: 'Standard',
      },
    },
  };
  const restoreObjectCommand = new RestoreObjectCommand(input);
  try {
    await client.send(restoreObjectCommand);
    console.log('Restore initiated for:', key);
  } catch (err) {
    console.error('Error during object restore:', err);
    throw err;
  }
};

/**
 * Checks the metadata of an S3 object including storage class and restoration
 * status. It also retrieves object tags and retention information if available.
 *
 * @param {string} fileKey - The S3 object key, prefixed with "safestorage://".
 * @return {Promise<Object>} An object containing metadata about the S3 object.
 */
export const headObject = async (fileKey) => {
  const key = fileKey.replace('safestorage://', '');
  console.log('Bucket: ', bucket);

  const input = {
    Bucket: bucket,
    Key: key,
  };
  const headObjectCommand = new HeadObjectCommand(input);
  const getObjectTaggingCommand = new GetObjectTaggingCommand(input);
  const getObjectRetentionCommand = new GetObjectRetentionCommand(input);

  let tags, retention;
  let glacier = false;
  let found = false;
  let isRestoring = false;
  let restored = false;

  // Try to get object metadata
  try {
    const response = await client.send(headObjectCommand);
    found = true;
    glacier =
      response.StorageClass === 'GLACIER' ||
      response.StorageClass === 'DEEP_ARCHIVE';
    if (response.Restore) {
      isRestoring = response.Restore.includes('ongoing-request="true"');
      restored = response.Restore.includes('ongoing-request="false"');
    }
  } catch (err) {
    console.error('Error retrieving the object:', err);
    return {
      fileKey,
      found,
    };
  }

  // Retrieve object tagging information
  try {
    const taggingResponse = await client.send(getObjectTaggingCommand);
    tags = taggingResponse.TagSet;
  } catch (err) {
    console.error("Error retrieving object's tags:", err);
  }

  // Retrieve object retention information
  try {
    const retentionResponse = await client.send(getObjectRetentionCommand);
    retention = retentionResponse.Retention;
  } catch (err) {
    console.error("Error retrieving object's retention information:", err);
  }

  return {
    fileKey,
    found,
    glacier,
    isRestoring,
    restored,
    tags,
    retention,
  };
};

/**
 * Retrieves an object from S3 or initiates a restore if the object is in
 * Glacier. Generates a signed URL for accessing the object if it is immediately
 * available.
 *
 * @param {string} fileKey - The S3 object key, prefixed with "safestorage://".
 * @return {Promise<Object>} An object containing the state of the object
 * retrieval or restore process.
 */
export const getObject = async (fileKey) => {
  const key = fileKey.replace('safestorage://', '');
  const input = {
    Bucket: bucket,
    Key: key,
  };

  try {
    const headResponse = await client.send(new HeadObjectCommand(input));
    console.log(headResponse);
    if (
      headResponse.StorageClass === 'GLACIER' ||
      headResponse.StorageClass === 'DEEP_ARCHIVE'
    ) {
      if (!headResponse.Restore) {
        // Initiate restore if not yet started.
        await restoreObject(bucket, key);
        return {
          fileKey,
          state: 'RESTORING',
          message: "Object restore initiated. Please try again later.",
        };
      } else if (headResponse.Restore.includes('ongoing-request="true"')) {
        return {
          fileKey,
          state: 'RESTORING',
          message: "Object restore already in progress. Please try again later.",
        };
      }
    }

    const getObjectCommand = new GetObjectCommand(input);
    // Generate a signed URL for direct object access if not in Glacier or already restored.
    const url = await getSignedUrl(client, getObjectCommand, {
      expiresIn: urlExpiresInSeconds,
    });
    return {
      fileKey,
      state: 'URL_GENERATED',
      url,
    };
  } catch (err) {
    err.message = err.name;
    console.error("Error generating object's URL:", err);
    throw err;
  }
};
