/// Which side of the marketplace the person is signing in as.
///
/// PROTOTYPE ONLY: for now the choice just decides which screens open after
/// login. When the backend exists, the role must be stored on the
/// server-side profile and enforced there, never trusted from the app.
enum UserRole { customer, vendor }
