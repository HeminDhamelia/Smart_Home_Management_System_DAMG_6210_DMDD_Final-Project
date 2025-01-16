USE SmartHomeManagement
GO
-- Create a database master key for encryption
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'YourStrongPassword123!';

-- Create a certificate for encrypting column data
CREATE CERTIFICATE DataEncryptionCert
WITH SUBJECT = 'Data Encryption Certificate';

-- Create a symmetric key for encryption
CREATE SYMMETRIC KEY DataSymmetricKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE DataEncryptionCert;

-- Encrypt the `email` column in the Person table
OPEN SYMMETRIC KEY DataSymmetricKey
DECRYPTION BY CERTIFICATE DataEncryptionCert;

UPDATE Person
SET email = ENCRYPTBYKEY(KEY_GUID('DataSymmetricKey'), email);

CLOSE SYMMETRIC KEY DataSymmetricKey;

-- Encrypt the `password` column in the Person table
OPEN SYMMETRIC KEY DataSymmetricKey
DECRYPTION BY CERTIFICATE DataEncryptionCert;

UPDATE Person
SET password = ENCRYPTBYKEY(KEY_GUID('DataSymmetricKey'), password);

CLOSE SYMMETRIC KEY DataSymmetricKey;

-- Encrypt the `payment_Status` column in the SubscriptionPlan table
OPEN SYMMETRIC KEY DataSymmetricKey
DECRYPTION BY CERTIFICATE DataEncryptionCert;

UPDATE SubscriptionPlan
SET payment_Status = ENCRYPTBYKEY(KEY_GUID('DataSymmetricKey'), payment_Status);

CLOSE SYMMETRIC KEY DataSymmetricKey;





/*Output*/




-- Decrypt and view the `email` column in the Person table
OPEN SYMMETRIC KEY DataSymmetricKey
DECRYPTION BY CERTIFICATE DataEncryptionCert;

SELECT 
    person_ID, 
    CONVERT(VARCHAR, DECRYPTBYKEY(email)) AS DecryptedEmail
FROM 
    Person;

CLOSE SYMMETRIC KEY DataSymmetricKey;

-- Decrypt and view the `password` column in the Person table
OPEN SYMMETRIC KEY DataSymmetricKey
DECRYPTION BY CERTIFICATE DataEncryptionCert;

SELECT 
    person_ID, 
    CONVERT(VARCHAR, DECRYPTBYKEY(password)) AS DecryptedPassword
FROM 
    Person;

CLOSE SYMMETRIC KEY DataSymmetricKey;

-- Decrypt and view the `payment_Status` column in the SubscriptionPlan table
OPEN SYMMETRIC KEY DataSymmetricKey
DECRYPTION BY CERTIFICATE DataEncryptionCert;

SELECT 
    plan_ID, 
    CONVERT(VARCHAR, DECRYPTBYKEY(payment_Status)) AS DecryptedPaymentStatus
FROM 
    SubscriptionPlan;

CLOSE SYMMETRIC KEY DataSymmetricKey;
