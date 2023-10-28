const PatientContract  = artifacts.require("PatientContract");

module.exports = function (deployer){
    deployer.deploy(PatientContract);
};