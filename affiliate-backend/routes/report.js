import express from "express";
import { getReport, exportExcel } from "../controllers/reportController.js";
import { verifyToken } from "../middleware/authMiddleware.js";

const router = express.Router();

router.get("/", verifyToken, getReport);
router.get("/export", verifyToken, exportExcel);

export default router;
