import { Router } from 'express';
import { AuthController } from './auth.controller';
import { validateBody } from '../../middleware/validate';
import { authLimiter } from '../../middleware/rateLimiter';
import { authenticate } from '../../middleware/authenticate';
import { registerSchema, loginSchema, googleLoginSchema, refreshTokenSchema } from './auth.schema';

const router = Router();
const authController = new AuthController();

router.post('/register', authLimiter, validateBody(registerSchema), authController.register);
router.post('/login', authLimiter, validateBody(loginSchema), authController.login);
router.post('/google', authLimiter, validateBody(googleLoginSchema), authController.googleLogin);
router.post('/refresh', validateBody(refreshTokenSchema), authController.refresh);
router.post('/logout', authenticate, authController.logout);

export const authRouter = router;
