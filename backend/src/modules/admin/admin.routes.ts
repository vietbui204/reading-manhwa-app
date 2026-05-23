import { Router } from 'express';
import { AdminController } from './admin.controller';
import { authenticate } from '../../middleware/authenticate';
import { authorize } from '../../middleware/authorize';
import { validateBody, validateQuery } from '../../middleware/validate';
import { adminUserQuerySchema, createTaskSchema, grantPointsSchema, updateRoleSchema, updateTaskSchema } from './admin.schema';

const router = Router();
const adminController = new AdminController();

// Tất cả route trong file này đều cần quyền Admin
router.use(authenticate, authorize('admin'));

router.get('/stats', adminController.getStats);
router.get('/users', validateQuery(adminUserQuerySchema), adminController.getUsers);
router.put('/users/:id/role', validateBody(updateRoleSchema), adminController.updateRole);

router.post('/tasks', validateBody(createTaskSchema), adminController.createTask);
router.put('/tasks/:id', validateBody(updateTaskSchema), adminController.updateTask);

router.post('/points/grant', validateBody(grantPointsSchema), adminController.grantPoints);

router.delete('/manga/:id', adminController.deleteManga);

export const adminRouter = router;
