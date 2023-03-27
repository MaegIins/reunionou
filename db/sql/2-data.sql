SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

INSERT INTO  `mode_paiement` (`id`,`libelle`) VALUES
(1,'Carte bancaire'),
(2,'Chèque'),
(3,'Espèces'),
(4,'Paypal');
INSERT INTO `commande` (`id`, `created_at`, `updated_at`, `livraison`, `nom`, `mail`, `montant`, `remise`, `token`, `client_id`, `ref_paiement`, `date_paiement`, `mode_paiement`, `status`) VALUES
('cdf6302b-940b-4348-b913-3cb2052bf042',	'2019-11-08 13:45:55',	'2019-11-08 13:45:55',	'2019-11-08 16:56:15',	'Dubois',	'Dubois@free.fr',	40.25,	NULL,	'543fc479e422715feb9562809cdd9ca54528426fae2ec0ff2382a32b937555c3',	NULL,	NULL,	NULL,	NULL,	1),
('169c491c-aa60-4251-b3a4-6972fea2aecc',	'2019-11-08 13:45:55',	'2019-11-08 13:45:55',	'2019-11-09 16:11:50',	'Payet',	'Payet@free.fr',	24.00,	NULL,	'2983d045d6026814ba0fe811b6cc535b0d3a65bfebb761645c38b51d5bd95392',	NULL,	'00423afe2b7f5e19e71632e2f7e5f2c52409ac49b7b78b06bc12b116e2962c2b937a9f3c5305fb217299c11101e4118a',	NULL,	NULL,	4),
('0b1c222a-94ae-4941-86f0-628795094945',	'2019-11-08 13:45:55',	'2019-11-08 13:45:55',	'2019-11-09 09:47:10',	'Bernard',	'Bernard@bouygtel.fr',	60.75,	NULL,	'78238f268c0eebfa7d2e996be0d297d5fbca8990ee1d024cd1a7ccb554f80805',	NULL,	'26c4b95051d5eec4885dd5dcc6cec43df99702a2232ee349480a424c7033f5b20dc4a93051006011c724920ea05bc7f8',	NULL,	NULL,	4),
('528a1fa8-7c13-45d1-88d1-3ab982f7b0e9',	'2019-11-08 13:45:55',	'2019-11-08 13:45:55',	'2019-11-10 05:06:35',	'Delmas',	'Delmas@sfr.fr',	24.00,	NULL,	'a5b99e7ee6de50a384bc9f9bff843511af13db8ff57d3365945242987ea228bf',	NULL,	'8b9a54dd4233bbbd0a1f69066841669fbc8f8b169891b46480aaeff55ec240bf61d0ce7c4dad3dffc3da3b6d9276e2a7',	NULL,	NULL,	4),
('14e22b0f-1b4c-449f-a3be-ce18aa2d416e',	'2019-11-08 13:45:55',	'2019-11-08 13:45:55',	'2019-11-11 12:45:22',	'Da Silva',	'Da Silva@ifrance.com',	18.00,	NULL,	'4bfc69cef6f024e473e9b40963a3e144fa9d3041a9f49d5fbd6fbbfdfd62f7be',	NULL,	'80b5ee8856888c8a48b7c65501bcfacacadfc7aebdb34a3ed2c93ac4b420f104e01d6075d7de0932d7d732b283058e67',	NULL,	NULL,	3),
('161f6efe-92b9-41b6-8251-7758195ee118',	'2019-11-08 13:45:55',	'2019-11-08 13:45:55',	'2019-11-09 05:46:37',	'Legros',	'Legros@tiscali.fr',	28.50,	NULL,	'be258e35217bca97a51dac0d9a4c7faf8737b364c2ea085d1e839e75cb0b5ec3',	NULL,	'2aff2c3571fc44e1b0ab5e8685215ed013067acbe458ebf36bd5e32840b983826a581a3369b2242c337446816f42bb7c',	NULL,	NULL,	3),
('dd0c77af-5782-4821-bda1-e65be1a99024',	'2019-11-08 13:45:55',	'2019-11-08 13:45:55',	'2019-11-08 21:22:33',	'Leger',	'Leger@live.com',	35.25,	NULL,	'21609badd6eaa44764a413fe526034d2115163a1ed313e4de67c4fee0c9ca50a',	NULL,	'59929b45c85dcbfcbc8e8f5d426fe43ca44cdcdff8a10a5405b065bf1e82d7a0eff93824842c3a3fac79baac3e5cd8da',	NULL,	NULL,	3),
('50c28c40-f305-43a4-8184-be3626644d95',	'2019-11-08 13:45:55',	'2019-11-08 13:45:56',	'2019-11-10 01:18:14',	'Delahaye',	'Delahaye@hotmail.fr',	43.25,	NULL,	'37272c4693c69672fabae16ce7b830d1fb6c1d40af3fb5f16c32771fbc530aa7',	NULL,	'980b01c12f2c144abb6aac4a1db50b449f2a59350d2f05757c14c87de800e57634dcb7b4e812b25b67d1eb35ee8b1a6a',	NULL,	NULL,	2),
('6d90caa2-b74a-4575-9b8a-bf237306d48b',	'2019-11-08 13:45:56',	'2019-11-08 13:45:56',	'2019-11-10 22:51:31',	'Roussel',	'Roussel@ifrance.com',	42.00,	NULL,	'1942de0de15222d581f5081fa432ce3825113c4105a284b344c9f106ca44a55c',	NULL,	NULL,	NULL,	NULL,	1),
('06d23c7f-3a7d-4499-b7f1-0bb53ae40495',	'2019-11-08 13:45:56',	'2019-11-08 13:45:56',	'2019-11-09 13:06:06',	'Collet',	'Collet@tiscali.fr',	5.75,	NULL,	'ec6b9ef90e6dec5948841cfd3cacf14427a9ca3fde2cd4d5ecbb125682633730',	NULL,	NULL,	NULL,	NULL,	1);

INSERT INTO `item` (`id`, `uri`, `libelle`, `tarif`, `quantite`, `command_id`) VALUES
(3012,	'/sandwichs/s19005',	'la mer',	5.25,	2,	'cdf6302b-940b-4348-b913-3cb2052bf042'),
(3013,	'/sandwichs/s19004',	'le forestier',	5.75,	3,	'cdf6302b-940b-4348-b913-3cb2052bf042'),
(3014,	'/sandwichs/s19001',	'le bucheron',	6.00,	1,	'cdf6302b-940b-4348-b913-3cb2052bf042'),
(3015,	'/sandwichs/s19003',	'les fajitas poulet',	6.50,	1,	'cdf6302b-940b-4348-b913-3cb2052bf042'),
(3016,	'/sandwichs/s19004',	'le forestier',	5.75,	2,	'169c491c-aa60-4251-b3a4-6972fea2aecc'),
(3017,	'/sandwichs/s19006',	'le panini',	6.00,	1,	'169c491c-aa60-4251-b3a4-6972fea2aecc'),
(3018,	'/sandwichs/s19003',	'les fajitas poulet',	6.50,	1,	'169c491c-aa60-4251-b3a4-6972fea2aecc'),
(3019,	'/sandwichs/s19003',	'les fajitas poulet',	6.50,	2,	'0b1c222a-94ae-4941-86f0-628795094945'),
(3020,	'/sandwichs/s19004',	'le forestier',	5.75,	1,	'0b1c222a-94ae-4941-86f0-628795094945'),
(3021,	'/sandwichs/s19006',	'le panini',	6.00,	4,	'0b1c222a-94ae-4941-86f0-628795094945'),
(3022,	'/sandwichs/s19001',	'le bucheron',	6.00,	3,	'0b1c222a-94ae-4941-86f0-628795094945'),
(3023,	'/sandwichs/s19006',	'le panini',	6.00,	4,	'528a1fa8-7c13-45d1-88d1-3ab982f7b0e9'),
(3024,	'/sandwichs/s19006',	'le panini',	6.00,	3,	'14e22b0f-1b4c-449f-a3be-ce18aa2d416e'),
(3025,	'/sandwichs/s19002',	'le jambon-beurre',	4.50,	2,	'161f6efe-92b9-41b6-8251-7758195ee118'),
(3026,	'/sandwichs/s19003',	'les fajitas poulet',	6.50,	3,	'161f6efe-92b9-41b6-8251-7758195ee118'),
(3027,	'/sandwichs/s19004',	'le forestier',	5.75,	3,	'dd0c77af-5782-4821-bda1-e65be1a99024'),
(3028,	'/sandwichs/s19006',	'le panini',	6.00,	3,	'dd0c77af-5782-4821-bda1-e65be1a99024'),
(3029,	'/sandwichs/s19003',	'les fajitas poulet',	6.50,	4,	'50c28c40-f305-43a4-8184-be3626644d95'),
(3030,	'/sandwichs/s19005',	'la mer',	5.25,	1,	'50c28c40-f305-43a4-8184-be3626644d95'),
(3031,	'/sandwichs/s19006',	'le panini',	6.00,	2,	'50c28c40-f305-43a4-8184-be3626644d95'),
(3032,	'/sandwichs/s19006',	'le panini',	6.00,	3,	'6d90caa2-b74a-4575-9b8a-bf237306d48b'),
(3033,	'/sandwichs/s19001',	'le bucheron',	6.00,	4,	'6d90caa2-b74a-4575-9b8a-bf237306d48b'),
(3034,	'/sandwichs/s19004',	'le forestier',	5.75,	1,	'06d23c7f-3a7d-4499-b7f1-0bb53ae40495');
