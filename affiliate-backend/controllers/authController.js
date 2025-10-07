import pool from "../db.js";
import jwt from "jsonwebtoken";

export const login = async (req, res) => {
    try {
        const { username, password } = req.body;
        const [rows] = await pool.query("SELECT * FROM users WHERE username = ?", [username]);

        if (rows.length === 0) return res.status(401).json({ message: "User not found" });

        const user = rows[0];
        if (user.password !== password) return res.status(401).json({ message: "Invalid password" });

        const token = jwt.sign(
            { id: user.user_id, role: user.role },
            "SECRETKEY",
            { expiresIn: "1h" }
        );

        res.json({ token, role: user.role });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};
