// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
contract PatientContract{
    uint256 public patientCount=0;

    struct Patient{
        uint256 id;
        string p_name;
        string p_mobileNo;
        string p_adharNo;
        string p_address;
        string p_age;
        string p_gender;
        string p_datetime;
    }
    mapping(uint256=>Patient) public patients;

    event RegisterPatientToDapp(uint256 id,string p_name,
        string p_mobileNo,
        string p_adharNo,
        string p_address,
        string p_age,
        string p_gender,
        string p_datetime);
    event DeletePatientToDapp(uint256 id);

    function registerPatientDapp(string memory _name,string memory _mobileNo,string memory _adharNo,string memory _address,string memory _age,string memory _gender,string memory _datetime) public {
        patients[patientCount] = Patient(patientCount,_name,_mobileNo,_adharNo,_address,_age,_gender,_datetime);
        emit RegisterPatientToDapp(patientCount, _name, _mobileNo, _adharNo, _address, _age, _gender, _datetime);
        patientCount++;
    }

    function deletePatientDapp(uint256 _id) public {
        delete patients[_id];
        emit DeletePatientToDapp(_id);
        patientCount--;
    }
}