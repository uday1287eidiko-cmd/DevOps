CREATE TABLE REST_APPLICATIONS (
    RESOURCE_PATH       VARCHAR2(255) PRIMARY KEY,
    APPLICATION_NAME    VARCHAR2(100) NOT NULL,
    APPLICATION_PATH    VARCHAR2(500) NOT NULL,
    SERVER_NAME         VARCHAR2(100) NOT NULL,
    SERVER_PORT         NUMBER(5)     NOT NULL,
    IS_ACTIVE           CHAR(1)       DEFAULT 'Y' CHECK (IS_ACTIVE IN ('Y', 'N'))
);

-- Optional comment for table documentation
COMMENT ON TABLE REST_APPLICATIONS IS 'Stores REST application routing details using resource path as primary key';




-- Ensure your logging table structure matches
CREATE TABLE ACEDB_LOGS (
    DATE_TIME        TIMESTAMP(6),
    MSG_ID           VARCHAR2(100),
    APPLICATION_NAME VARCHAR2(100),
    BROKER_NAME      VARCHAR2(100),
    PAYLOAD          CLOB
);



CREATE OR REPLACE PROCEDURE ACEDBLOGGING (
    p_date_time        IN TIMESTAMP,
    p_msg_id           IN VARCHAR2,
    p_application_name IN VARCHAR2,
    p_broker_name      IN VARCHAR2,
    p_payload          IN CLOB
) AS
BEGIN
    INSERT INTO ACEDB_LOGS (
        DATE_TIME,
        MSG_ID,
        APPLICATION_NAME,
        BROKER_NAME,
        PAYLOAD
    ) VALUES (
        p_date_time,
        p_msg_id,
        p_application_name,
        p_broker_name,
        p_payload
    );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END ACEDBLOGGING;
/

INSERT INTO REST_APPLICATIONS (RESOURCE_PATH, APPLICATION_NAME, APPLICATION_PATH, SERVER_NAME, SERVER_PORT) 
VALUES ('account-lookup', 'AccountInquiryService', 'http://localhost:7800/v1/account/inquire/account-lookup', 'LegacyAccountService', 7800);

INSERT INTO REST_APPLICATIONS (RESOURCE_PATH, APPLICATION_NAME, APPLICATION_PATH, SERVER_NAME, SERVER_PORT) 
VALUES ('trxn-history', 'TransactionHistoryInquiry', 'http://localhost:7800/v1/transactionhistoryapi/trxn-history', 'LegacyAccountService', 7800);

SELECT RESOURCE_PATH ,
APPLICATION_NAME ,
APPLICATION_PATH ,
SERVER_NAME ,
SERVER_PORT ,
IS_ACTIVE  FROM REST_APPLICATIONS WHERE RESOURCE_PATH = 'account-inquiry';

UPDATE REST_APPLICATIONS
SET RESOURCE_PATH = 'account-inquiry'
WHERE RESOURCE_PATH = 'account-lookup';
commit;


SELECT * FROM ACEDB_LOGS WHERE MSG_ID = 'luffy453466';