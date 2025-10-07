import express from "express";
import {
    getMembers,
    createMember,
    updateMember,
    deleteMember,
    getManagers
} from "../controllers/memberController.js";

import { verifyToken, isAdmin } from "../middleware/authMiddleware.js";

const router = express.Router();

// Semua butuh login
router.get("/", verifyToken, getMembers);

// Admin only untuk CRUD
router.post("/", verifyToken, isAdmin, createMember);
router.put("/:id", verifyToken, isAdmin, updateMember);
router.delete("/:id", verifyToken, isAdmin, deleteMember);

// Manager list → boleh diakses semua yang login
router.get("/managers", verifyToken, getManagers);

export default router;
