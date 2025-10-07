import pool from "../db.js";

export const getMembers = async (req, res) => {
    const [rows] = await pool.query("SELECT * FROM member");
    res.json(rows);
};

export const createMember = async (req, res) => {
    const { m_branch_id, m_rep_id, m_name, m_current_position, m_manager_id } = req.body;
    await pool.query(
        "INSERT INTO member (m_branch_id, m_rep_id, m_name, m_current_position, m_manager_id) VALUES (?, ?, ?, ?, ?)",
        [m_branch_id, m_rep_id, m_name, m_current_position, m_manager_id]
    );
    res.json({ message: "Member created" });
};

export const updateMember = async (req, res) => {
    const { id } = req.params;
    const { m_branch_id, m_name, m_current_position, m_manager_id } = req.body;
    await pool.query(
        "UPDATE member SET m_branch_id=?, m_name=?, m_current_position=?, m_manager_id=? WHERE m_rep_id=?",
        [m_branch_id, m_name, m_current_position, m_manager_id, id]
    );
    res.json({ message: "Member updated" });
};

export const deleteMember = async (req, res) => {
    const { id } = req.params;
    await pool.query("DELETE FROM member WHERE m_rep_id=?", [id]);
    res.json({ message: "Member deleted" });
};

export const getManagers = async (req, res) => {
    const [rows] = await pool.query(
        "SELECT m_rep_id, m_name FROM member WHERE m_current_position IN ('EPD','GEPD')"
    );
    res.json(rows);
};
