import {
  GetObjectCommand,
  GetObjectTaggingCommand,
  GetObjectRetentionCommand,
  HeadObjectCommand,
  RestoreObjectCommand,
  S3Client,
} from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { getSafeStorageBucket, getS3AWSRegion } from './config.js';

const client = new S3Client({ region: getS3AWSRegion() });
const bucket = getSafeStorageBucket();

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
    console.log('Restore iniziato per:', key);
  } catch (err) {
    console.error("Errore durante il restore dell'oggetto:", err);
    throw err;
  }
};

export const headObject = async (aarKey) => {
  const key = aarKey.replace('safestorage://', '');
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
    console.error("Errore durante il recupero dell'oggetto:", err);
    return {
      aarKey,
      found,
    };
  }

  try {
    const taggingResponse = await client.send(getObjectTaggingCommand);
    tags = taggingResponse.TagSet;
  } catch (err) {
    console.error("Errore durante il recupero dei tag dell'oggetto:", err);
  }

  try {
    const retentionResponse = await client.send(getObjectRetentionCommand);
    retention = retentionResponse.Retention;
  } catch (err) {
    console.error(
      'Errore durante il recupero delle informazioni di retention:',
      err,
    );
  }

  return {
    aarKey,
    found,
    glacier,
    isRestoring,
    restored,
    tags,
    retention,
  };
};

export const getObject = async (aarKey) => {
  const key = aarKey.replace('safestorage://', '');
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
        await restoreObject(bucket, key); // Avvia il restore se necessario
        return {
          aarKey,
          state: 'RESTORING',
          message: "Restore dell'oggetto iniziato. Riprovare più tardi.",
        };
      } else if (headResponse.Restore.includes('ongoing-request="true"')) {
        return {
          aarKey,
          state: 'RESTORING',
          message: "Restore dell'oggetto già iniziato. Riprovare più tardi.",
        };
      }
    }

    const getObjectCommand = new GetObjectCommand(input);
    const url = await getSignedUrl(client, getObjectCommand, {
      expiresIn: 5 * 60,
    }); // 5 minutes
    console.log(url);
    return {
      aarKey,
      state: 'URL_GENERATED',
      url,
    };
  } catch (err) {
    console.error("Errore durante la generazione dell'URL dell'oggetto:", err);
    throw err;
  }
};
