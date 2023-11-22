// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
contract PatientContract{
    uint256 public patientCount=0;

    struct Patient{
        string p_name;
        string p_mobileNo;
        string p_adharNo;
        string p_address;
        //uint256 p_datetime;
        uint256 p_age;
        bool p_gender;
        bool p_isPaidCheckupFees;
    }
    mapping(uint256=>Patient) public patients;

    event RegisterPatientToDapp(
      
        string p_name,
        string p_mobileNo,
        string p_adharNo,
        string p_address,
        uint256 p_age,
        bool p_gender,
        bool p_isPaidCheckupFees
        );
    event DeletePatientToDapp(uint256 id);

    function registerPatientDapp(
        // uint256 id,
        string memory p_name,
        string memory p_mobileNo,
        string memory p_adharNo,
        string memory p_address,
        //uint256 p_datetime,
        uint256 p_age,
        bool p_gender,
        bool p_isPaidCheckupFees
        ) 
        public {
        patients[patientCount] = 
        Patient(p_name,p_mobileNo,p_adharNo,p_address,p_age,p_gender,p_isPaidCheckupFees);

        emit RegisterPatientToDapp(p_name, p_mobileNo, p_adharNo, p_address, p_age, p_gender,p_isPaidCheckupFees);
        patientCount++;
    }

    function deletePatientDapp(uint256 _id) public {
        delete patients[_id];
        emit DeletePatientToDapp(_id);
        patientCount--;
    }
}