import RegisterForm from "../components/RegisterForm";

const RegisterScreen = () => {
  return (
    <>
      <div className="container">
        <div className="row justify-content-md-center">
          <div className="col-8">
            <div className="mb-5">
              <RegisterForm />
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default RegisterScreen;
