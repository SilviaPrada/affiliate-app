import jwt from "jsonwebtoken";

export const verifyToken = (req, res, next) => {
    const authHeader = req.headers["authorization"];
    const token = authHeader && authHeader.split(" ")[1]; // "Bearer TOKEN"

    if (!token) return res.status(401).json({ message: "No token provided" });

    jwt.verify(token, "SECRETKEY", (err, user) => {
        if (err) return res.status(403).json({ message: "Invalid token" });

        req.user = user; // simpan info user ke request
        next();
    });
};

export const isAdmin = (req, res, next) => {
    if (req.user.role !== "Administrator") {
        return res.status(403).json({ message: "Access denied. Admin only." });
    }
    next();
};
