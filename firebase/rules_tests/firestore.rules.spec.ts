import { initializeTestEnvironment, RulesTestEnvironment } from '@firebase/rules-unit-testing';
import { readFileSync } from 'fs';

describe('Firestore security rules', () => {
  let testEnv: RulesTestEnvironment;

  beforeAll(async () => {
    testEnv = await initializeTestEnvironment({
      projectId: 'senioren-app-test',
      firestore: {
        rules: readFileSync('../firestore.rules', 'utf8'),
      },
    });
  });

  afterAll(async () => {
    await testEnv.cleanup();
  });

  it('allows users to read their own profile', async () => {
    const userContext = testEnv.authenticatedContext('user-1');
    const doc = userContext.firestore().doc('users/user-1');
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await context.firestore().doc('users/user-1').set({ displayName: 'Test' });
    });
    await expect(doc.get()).toAllow();
  });

  it('blocks emergency contact creation beyond limit', async () => {
    const userContext = testEnv.authenticatedContext('user-1');
    await testEnv.withSecurityRulesDisabled(async (context) => {
      const base = context.firestore().collection('contacts').doc('user-1').collection('items');
      for (let i = 0; i < 3; i += 1) {
        await base.add({ name: `Kontakt ${i}`, phone: '123', isEmergency: true, createdAt: new Date() });
      }
    });
    const attempt = userContext
      .firestore()
      .collection('contacts')
      .doc('user-1')
      .collection('items')
      .doc('new');
    await expect(
      attempt.set({ name: 'Test', phone: '123', isEmergency: true, createdAt: new Date() }),
    ).toDeny();
  });
});
