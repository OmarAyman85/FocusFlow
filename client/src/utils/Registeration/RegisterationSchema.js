import Joi from "joi-browser";

// Define the schema
const registerUserSchema = Joi.object({
  name: Joi.string().min(3).max(50).required(),

  email: Joi.string().email().required(),

  password: Joi.string().min(8).max(128).required(),

  phone: Joi.string(),

  address: Joi.object({
    street: Joi.string().max(100).allow(""),
    city: Joi.string().max(50).allow(""),
    state: Joi.string().max(50).allow(""),
    country: Joi.string().max(50).allow(""),
    postalCode: Joi.string().allow(""),
  }).default({}),

  role: Joi.string().valid("user", "admin", "moderator").default("user"),

  profileImage: Joi.string().uri().allow("").default("default-profile.png"),

  dateOfBirth: Joi.date().iso().less("now"),

  socialAccounts: Joi.object({
    facebook: Joi.string().uri().allow(""),
    twitter: Joi.string().uri().allow(""),
    linkedin: Joi.string().uri().allow(""),
    instagram: Joi.string().uri().allow(""),
  }).default({}),
});

// Export the schema
export default registerUserSchema;
