/// Custom exception class to handle various Firebase authentication-related errors.
// ignore_for_file: unreachable_switch_case, dangling_library_doc_comments

class TFirebaseAuthException implements Exception {
  /// The error code associated with the exception.
  final String code;

  /// Constructor that takes an error code.
  TFirebaseAuthException(this.code);

  /// Get the corresponding error message based on the error code.
  String get message {
    switch (code) {
      case 'email-already-in-use':
        return 'このメールアドレスは既に登録されています。別のメールアドレスを使用してください。';
      case 'invalid-email':
        return '入力されたメールアドレスが無効です。有効なメールアドレスを入力してください。';
      case 'weak-password':
        return 'パスワードが弱すぎます。より強力なパスワードを選択してください。';
      case 'user-disabled':
        return 'このユーザーアカウントは無効になっています。サポートに連絡してください。';
      case 'user-not-found':
        return '無効なログイン情報です。ユーザーが見つかりません。';
      case 'wrong-password':
        return 'パスワードが間違っています。もう一度確認してください。';
      case 'invalid-verification-code':
        return '確認コードが無効です。有効なコードを入力してください。';
      case 'invalid-verification-id':
        return '確認IDが無効です。新しい確認コードをリクエストしてください。';
      case 'quota-exceeded':
        return 'クォータを超えました。しばらくしてから再試行してください。';
      case 'email-already-exists':
        return 'このメールアドレスは既に存在します。別のメールアドレスを使用してください。';
      case 'provider-already-linked':
        return 'このアカウントは別のプロバイダーと既にリンクされています。';
      case 'requires-recent-login':
        return 'この操作には最近の認証が必要です。再度ログインしてください。';
      case 'credential-already-in-use':
        return 'この認証情報は既に別のユーザーアカウントに関連付けられています。';
      case 'user-mismatch':
        return '提供された認証情報が以前にサインインしたユーザーと一致しません。';
      case 'account-exists-with-different-credential':
        return '同じメールアドレスのアカウントが異なる認証情報で既に存在します。';
      case 'operation-not-allowed':
        return 'この操作は許可されていません。サポートに連絡してください。';
      case 'expired-action-code':
        return 'アクションコードの有効期限が切れています。新しいコードをリクエストしてください。';
      case 'invalid-action-code':
        return 'アクションコードが無効です。コードを確認して再試行してください。';
      case 'missing-action-code':
        return 'アクションコードが見つかりません。有効なアクションコードを入力してください。';
      case 'user-token-expired':
        return 'ユーザーのトークンの有効期限が切れています。再度ログインしてください。';
      case 'invalid-credential':
        return '提供された認証情報が無効または期限切れです。';
      case 'user-token-revoked':
        return 'ユーザーのトークンが無効になりました。再度ログインしてください。';
      case 'invalid-message-payload':
        return 'メールテンプレートの確認メッセージのペイロードが無効です。';
      case 'invalid-sender':
        return 'メールテンプレートの送信者が無効です。送信者のメールアドレスを確認してください。';
      case 'invalid-recipient-email':
        return '受信者のメールアドレスが無効です。有効なメールアドレスを入力してください。';
      case 'missing-iframe-start':
        return 'メールテンプレートにiframeの開始タグがありません。';
      case 'missing-iframe-end':
        return 'メールテンプレートにiframeの終了タグがありません。';
      case 'missing-iframe-src':
        return 'メールテンプレートにiframeのsrc属性がありません。';
      case 'auth-domain-config-required':
        return 'アクションコードの確認リンクにはauthDomainの設定が必要です。';
      case 'missing-app-credential':
        return 'アプリの認証情報が不足しています。有効な認証情報を提供してください。';
      case 'invalid-app-credential':
        return 'アプリの認証情報が無効です。有効な認証情報を提供してください。';
      case 'session-cookie-expired':
        return 'Firebaseセッションクッキーの有効期限が切れました。再度ログインしてください。';
      case 'uid-already-exists':
        return '提供されたユーザーIDは既に使用されています。';
      case 'invalid-cordova-configuration':
        return '提供されたCordovaの設定が無効です。';
      case 'app-deleted':
        return 'このFirebaseAppインスタンスは削除されました。';
      case 'user-token-mismatch':
        return '提供されたユーザーのトークンが認証されたユーザーIDと一致しません。';
      case 'web-storage-unsupported':
        return 'Webストレージがサポートされていないか、無効になっています。';
      case 'app-not-authorized':
        return 'このアプリは提供されたAPIキーでFirebase認証を使用する許可がありません。';
      case 'keychain-error':
        return 'キーチェーンエラーが発生しました。キーチェーンを確認してください。';
      case 'internal-error':
        return '内部認証エラーが発生しました。後でもう一度試してください。';
      case 'INVALID_LOGIN_CREDENTIALS':
        return '無効なログイン認証情報です。';
      default:
        return '予期しない認証エラーが発生しました。もう一度お試しください。';
    }
  }
}
