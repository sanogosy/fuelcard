import 'package:firebase_auth/firebase_auth.dart';

// const apiUrl = 'http://192.168.43.74:80/api/weli_enterprise/';
const apiUrl = 'http://192.168.1.76:80/api/weli_enterprise/';
const apiGetUserFile = 'getUser.php';
const apiGetProfileFile = 'profile.php';
const apiTransfertOperationFile = 'transfert_operations.php';
const apiTransfertFile = 'transfert.php';
const apiHistoriqueOperationNonTransferesSousReseauFile = 'historique_operation_non_transfere_sousreseau.php';
const apiDemandeAchatCarburantFile = 'demande_achat_carburant.php';
const apiAccountBalanceFile = 'account_balance.php';
const apiAbonnementRoutierFile = 'abonnement_routier.php';

const apiDemandeAchatFile = 'initier_achat_carburant.php';

// final number='0${FirebaseAuth.instance.currentUser!.phoneNumber!.substring(3,13)}';
final currentUserCountryCode='';
final number='${FirebaseAuth.instance.currentUser!.phoneNumber!.substring(1,12)}';
const customerId = 'customerid';
// const currentUserUid = 'UID';
const currentUserName = 'NAME';
const currentUserPhone = 'PHONE';
const currentUserEmail = 'EMAIL';
const currentUserPhotoUrl = 'URL';
const firebaseChannelDB = 'ChatChannels';
const firebaseChannelMessageDB = 'ChatChannelMessage';
const firebaseChannelLastMessageDB = 'ChatChannelLastMessage';
const firebaseChannelCategoryDB = 'ChatChannelCategory';
const firebaseChannelUserDB = 'ChatUserChannels';
const firebaseAccountDB = 'Accounts';
const firebaseEnterpriseUsersDB = 'EnterpriseUsers';
const firebaseChatsDB = 'Chats';
const firebaseChatDB = 'Chat';
const contributionTeamRef = 'ContributionTeam';
const contributionTeamMessageRef = 'ContributionTeamMessage';
const contributionTeamAuthorizationRef = 'ContributionTeamAuthorization';
const accountAlreadyExists = 'Ce compte existe déjà !';
const accountNotExists = 'Erreur identifiants incorrects';