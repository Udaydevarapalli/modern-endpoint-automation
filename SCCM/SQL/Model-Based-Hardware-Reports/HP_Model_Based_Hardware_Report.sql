SELECT
    SYS.ResourceID                         AS [Resource ID],
    SYS.Name0                              AS [Device Name],
    SYS.User_Name0                         AS [Last Logged On User],
    CS.Manufacturer0                      AS [Manufacturer],
    CS.Model0                             AS [Model],
    SYS.Client_Version0                   AS [Client Version],
    SYS.Operating_System_Name_and0        AS [Operating System],
    SYS.Last_Logon_Timestamp0             AS [Last Logon],
    SYS.AD_Site_Name0                     AS [AD Site]
FROM v_R_System SYS
INNER JOIN v_GS_COMPUTER_SYSTEM CS
    ON SYS.ResourceID = CS.ResourceID
WHERE
    CS.Manufacturer0 LIKE '%HP%'
    AND (
        CS.Model0 LIKE '%EliteBook x360 1040 G6%'
        OR CS.Model0 LIKE '%EliteBook x360 1040 G5%'
        OR CS.Model0 LIKE '%EliteDesk 800 G3 SFF%'
    )
ORDER BY
    CS.Model0,
    SYS.Name0;
