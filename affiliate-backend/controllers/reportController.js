import pool from "../db.js";
import ExcelJS from "exceljs";

// Get Report (untuk API)
export const getReport = async (req, res) => {
  const [rows] = await pool.query(`
    SELECT 
        m3.m_rep_id AS m_mst_gepd,
        m3.m_name AS NamaGEPD,
        m2.m_rep_id AS m_mst_epd,
        m2.m_name AS NamaEPD,
        m1.m_branch_id,
        m1.m_name
    FROM member m1
    LEFT JOIN member m2 ON m1.m_manager_id = m2.m_rep_id
    LEFT JOIN member m3 ON m2.m_manager_id = m3.m_rep_id
    WHERE m1.m_current_position = 'EPC'
    ORDER BY m3.m_name, m2.m_name, m1.m_name
  `);
  res.json(rows);
};

// Export Excel
export const exportExcel = async (req, res) => {
  const [rows] = await pool.query(`
    SELECT 
        m3.m_rep_id AS m_mst_gepd,
        m3.m_name AS NamaGEPD,
        m2.m_rep_id AS m_mst_epd,
        m2.m_name AS NamaEPD,
        m1.m_branch_id,
        m1.m_name
    FROM member m1
    LEFT JOIN member m2 ON m1.m_manager_id = m2.m_rep_id
    LEFT JOIN member m3 ON m2.m_manager_id = m3.m_rep_id
    WHERE m1.m_current_position = 'EPC'
    ORDER BY m3.m_name, m2.m_name, m1.m_name
  `);

  const workbook = new ExcelJS.Workbook();
  const worksheet = workbook.addWorksheet("Report");

  worksheet.columns = [
    { header: "m_mst_gepd", key: "m_mst_gepd", width: 15 },
    { header: "NamaGEPD", key: "NamaGEPD", width: 25 },
    { header: "m_mst_epd", key: "m_mst_epd", width: 15 },
    { header: "NamaEPD", key: "NamaEPD", width: 25 },
    { header: "m_branch_id", key: "m_branch_id", width: 10 },
    { header: "m_name", key: "m_name", width: 25 },
  ];

  worksheet.addRows(rows);

  // Tambahkan style header
  worksheet.getRow(1).eachCell((cell) => {
    cell.font = { bold: true, color: { argb: "FFFFFFFF" } };
    cell.fill = {
      type: "pattern",
      pattern: "solid",
      fgColor: { argb: "FF4C7CF4" },
    };
    cell.alignment = { horizontal: "center", vertical: "middle" };
    cell.border = {
      top: { style: "thin" },
      left: { style: "thin" },
      bottom: { style: "thin" },
      right: { style: "thin" },
    };
  });

  res.setHeader(
    "Content-Type",
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  );
  res.setHeader("Content-Disposition", "attachment; filename=report.xlsx");

  await workbook.xlsx.write(res);
  res.end();
};
