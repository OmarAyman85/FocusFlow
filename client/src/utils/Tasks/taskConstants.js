export const statusEnum = ["pending", "in-progress", "completed"];
export const priorityEnum = ["low", "medium", "high"];
export const getUserInfo = () =>
  JSON.parse(localStorage.getItem("userInfo")) || {};

export const getConfig = () => {
  const { token } = getUserInfo();
  return token
    ? { headers: { Authorization: `Bearer ${token}` } }
    : { headers: { "Content-Type": "application/json" } };
};
