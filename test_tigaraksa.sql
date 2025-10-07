USE test_tigaraksa;

-- 1. Buat tabel member
CREATE TABLE member (
    m_branch_id VARCHAR(10) NOT NULL,
    m_rep_id VARCHAR(10) NOT NULL PRIMARY KEY,
    m_name VARCHAR(100) NOT NULL,
    m_current_position VARCHAR(50),
    m_manager_id VARCHAR(10)
);

-- 2. Insert data ke tabel member
INSERT INTO member (m_branch_id, m_rep_id, m_name, m_current_position, m_manager_id) VALUES
('BDG', 'BD03177', 'SHINTA DAMAYANTIE', 'EPC', 'JK03320'),
('PKB', 'PK00068', 'NIA SEMARTIANA', 'EPC', 'JK03320'),
('BKS', 'BK00158', 'FARAH AMALIA', 'EPC', 'BD03143'),
('BDG', 'BD03203', 'ROBI ACHIRUDIN.S', 'EPC', 'BD03143'),
('JGY', 'JG00928', 'SUSIAMI INDRIANI', 'EPC', 'PL00205'),
('MDN', 'MD00464', 'SARAH PAMELA', 'EPC', 'PL00205'),
('SBY', 'SB01310', 'HANATRI PUTRI MARATONI', 'EPC', 'SB01153'),
('TGR', 'TG00154', 'YANA FEBRINA', 'EPC', 'SB01153'),
('JKT', 'JK03320', 'EDO APRIANTO', 'GEPD', 'JK03320'),
('BDG', 'BD03143', 'NUR ISLAMI Y LUTHF', 'EPD', 'JK03320'),
('PLB', 'PL00205', 'FITRI HANDAYANI, A', 'EPD', 'JK03320'),
('SBY', 'SB01153', 'MARIA LUAILIA', 'GEPD', 'SB01153');

-- 3. Select query untuk menampilkan hierarki GEPD -> EPD -> EPC
SELECT 
    gepd.m_rep_id AS m_mst_gepd,
    gepd.m_name   AS NamaGEPD,
    epd.m_rep_id  AS m_mst_epd,
    epd.m_name    AS NamaEPD,
    epc.m_branch_id,
    epc.m_name
FROM member AS epc
JOIN member AS epd 
    ON epc.m_manager_id = epd.m_rep_id
JOIN member AS gepd 
    ON epd.m_manager_id = gepd.m_rep_id
WHERE epc.m_current_position = 'EPC'
ORDER BY gepd.m_rep_id, epd.m_rep_id, epc.m_rep_id;