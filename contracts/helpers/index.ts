export const formatTokenUri = (tokenURI: string) => {
  const formattedUri = tokenURI.replace(/^data:\w+\/\w+;base64,/, "");

  const jsonString = Buffer.from(formattedUri, "base64").toString("ascii");
  return JSON.parse(jsonString);
};