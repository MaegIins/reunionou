SET foreign_key_checks = 0;

SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

-- Insertion des lieux (Places)
INSERT INTO `Place` (`id`, `name`, `adress`, `lat`, `lon`) VALUES
('589fd4aa-a728-4a66-bec2-493109a161d3', 'Parc de la Pépinière', 'Rue Gabriel Mouilleron, 54000 Nancy', 48.689880, 6.182020),
('ff849560-dafa-40d0-b044-dbf7ae85d6f3', 'Palais des Ducs de Lorraine', 'Place Stanislas, 54000 Nancy', 48.693450, 6.182370),
('afff70cf-a491-43b8-b889-e8ec466c5f91', 'Musée des Beaux-Arts de Nancy', '3 Place Stanislas, 54000 Nancy', 48.693470, 6.183430),
('cd780831-a695-4de2-b6d4-fa5ec24bc51f', 'Cathédrale Notre-Dame-de-l Annonciation', 'Place Charles III, 54000 Nancy', 48.694490, 6.183860);

-- Insertion des événements (Events)
INSERT INTO `Event` (`id`, `name`, `description`, `date`, `name_orga`, `mail_orga`, `id_place`) VALUES
('7904c62f-3d4f-446f-8a23-56c5660f466f', 'Fête de la Musique', 'La Fête de la Musique est une fête populaire, gratuite et ouverte à tous les musiciens.', '2023-04-21 18:00:00', 'Jean Dupont', 'jean.dupont@mail.com', '589fd4aa-a728-4a66-bec2-493109a161d3'),
('9a105e54-cd03-4559-91d7-263de33aa7ef', 'Exposition Monet', 'Exposition des oeuvres de Monet, peintre impressionniste', '2023-08-01 10:00:00', 'Lucie Bernard', 'lucie.bernard@mail.com', 'afff70cf-a491-43b8-b889-e8ec466c5f91');

-- Insertion des participants (Attendees)
INSERT INTO `Attendee` (`id`, `id_event`, `name_user`, `mail_user`, `status`, `details`) VALUES
('1', '7904c62f-3d4f-446f-8a23-56c5660f466f', 'Jean Dupont', 'jean.dupont@mail.com', '3', 'Je viens avec ma guitare'),
('2', '7904c62f-3d4f-446f-8a23-56c5660f466f', 'Marie Martin', 'marie.martin@mail.com', '0', NULL),
('3', '9a105e54-cd03-4559-91d7-263de33aa7ef', 'Lucie Bernard', 'lucie.bernard@mail.com', '3', 'Musée, youpiii');
('4', '9a105e54-cd03-4559-91d7-263de33aa7ef', 'Paul Dupont', 'pauk@mail.com', '2', 'Trop hâte !')


-- Insertion des commentaires (Comments)
INSERT INTO `Comments` (`id`,`id_event`, `id_attendee`, `text`, `date`) VALUES
('a9ec9454-7dad-401f-a6f2-f118aa77e9a1','7904c62f-3d4f-446f-8a23-56c5660f466f', '1', 'Super événement !', '2023-06-22 09:00:00'),
('3144d9e7-a7b6-45ee-8539-56e2b6a0f750','7904c62f-3d4f-446f-8a23-56c5660f466f', '2', 'Dommage qu il ait plu...', '2023-06-22 09:30:00'),
('6530c96b-450d-4eb3-9995-cdf5d54ebf83','9a105e54-cd03-4559-91d7-263de33aa7ef', '3', 'Magnifique exposition !', '2023-08-01 12:00:00');