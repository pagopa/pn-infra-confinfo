/**
 * Creates a response object suitable for returning from a web service endpoint.
 *
 * @param {number} statusCode - The HTTP status code for the response.
 * @param {Object} body - The content of the response body. If provided, this
 * will be JSON stringified.
 * @returns {Object} An object representing the HTTP response, with a
 * 'statusCode' and a 'body' property.
 */
export const makeResponse = (statusCode, body) => {
  return {
    statusCode,
    body: JSON.stringify(body),
  };
};
