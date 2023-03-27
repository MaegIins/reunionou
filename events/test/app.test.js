const request = require("supertest");
const app = require("../app");

describe("Test du router index.js", () => {
    test("Code HTTP 200 attendu", async () => {
        const response = await request(app).get("/");
        expect(response.statusCode).toBe(200);
    });

    test("Réponse au format json attendue avec le contenu : {message:'Hello, World !'}", async () => {
        const response = await request(app).get("/").set('accept', 'json');
        expect(response.body.message).toMatch("Hello, World !");
    });

    test("Test de création d'une tâche (Task), code HTTP 201 attendu", async () => {
        const response = await request(app).post("/orders").send({ user_id: 1, content: "Acheter du pain pour ce soir" }).set('accept', 'json');
        expect(response.statusCode).toBe(201);
    });

    test("Test de lecture des tâches et vérification de la présence de la tâche qui vient d'être ajoutée", async () => {
        const response = await request(app).get("/orders").set('accept', 'json');

        const data = response.body.data;

        expect(data).toEqual(
            expect.arrayContaining([
                expect.objectContaining(
                    { content: "Acheter du pain pour ce soir", user_id: 1 },
                )
            ]
            )
        );

    });
});
