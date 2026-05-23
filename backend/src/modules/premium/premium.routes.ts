import { Router } from 'express';
import { PremiumController } from './premium.controller';
import { authenticate } from '../../middleware/authenticate';
import { authorize } from '../../middleware/authorize';

const router = Router();
const premiumController = new PremiumController();

router.get('/status', authenticate, premiumController.getStatus);
router.get('/plans', premiumController.getPlans);
router.post('/activate', authenticate, authorize('admin'), premiumController.activate);

export const premiumRouter = router;
