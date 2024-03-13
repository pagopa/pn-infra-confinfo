import { handleEvent } from "./src/app/eventHandler.js";

export const handler = async (event) => {
  return handleEvent(event)
};