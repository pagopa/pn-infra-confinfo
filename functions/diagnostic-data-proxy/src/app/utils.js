export class CheckKeysError extends Error {}

/**
 * Validates the keys and their types in a given object against a specified list
 * of keys and types. If a key is missing or has a type different from the
 * specified type, an error is thrown.
 *
 * @param {Object} obj - The object to validate.
 * @param {Array<Array<string>>} keysAndTypes - An array of [key, type] pairs
 * where 'key' is the string name of the key to check in the object, and 'type'
 * is the expected JavaScript type as a string (e.g., 'string', 'number').
 * @throws {CheckKeysError} - Throws a CheckKeysError with a message detailing
 * the missing or invalid keys if any discrepancies are found.
 */
export const checkKeys = (obj, keysAndTypes) => {
  let errors = [];

  keysAndTypes.forEach(([key, type]) => {
    if (!obj.hasOwnProperty(key)) {
      errors.push(`Missing '${key}' attribute.`);
    } else if (typeof obj[key] !== type) {
      errors.push(`Invalid '${key}' attribute, it must be of type ${type}.`);
    }
  });

  if(errors.length > 0){
    throw new CheckKeysError('Invalid event object: ' + errors.join(' '));
  }
  return obj;
};

/**
 * Creates a response object suitable for returning from a web service endpoint.
 *
 * @param {number} statusCode - The HTTP status code for the response.
 * @param {Object} body - The content of the response body. If provided, this will be
 * JSON stringified.
 * @returns {Object} An object representing the HTTP response, with a
 * 'statusCode' and a 'body' property.
 */
export const makeResponse = (statusCode, body) => {
  return JSON.stringify({
    statusCode,
    body
  });
};
