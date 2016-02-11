# Datcord
Library to make interacting with Discord in Elixir easier.

## Progress

### Mix tasks
- [x] Login Mix task

### HTTP API
- [x] Authentication
  - [x] Login
- [x] Channels
  - [x] General
    - [x] Create Channel
    - [x] Edit Channel
    - [x] Delete Channel
    - [x] Broadcast Typing
  - [x] Messages
    - [x] Get Messages
    - [x] Send Message
    - [x] Edit Message
    - [x] Delete Message
    - [x] Acknowledge Message
  - [x] Permissions
    - [x] Credit/Edit Permission
    - [x] Delete Permission
- [ ] Guilds
  - [x] General
    - [x] Create Guild
    - [x] Edit Guild
    - [x] Delete/Leave Guild
    - [ ] Get Guild Channels
  - [ ] Members
    - [ ] Edit Member
    - [ ] Kick Member
  - [ ] Bans
    - [ ] Get Bans
    - [ ] Add Ban
    - [ ] Remove Ban
  - [ ] Roles
    - [ ] Create Role
    - [ ] Edit Role
    - [ ] Redorder Roles
    - [ ] Delete Roles
- [ ] Invites
  - [ ] Get Invite
  - [ ] Accept Invite
  - [ ] Create Invite
  - [ ] Delete Invite
- [ ] Users
  - [ ] General
    - [ ] Create Private Channel
    - [ ] Get Avatar
  - [ ] Profile
    - [ ] Edit Profile

### WebSockets
- [x] Successful connection
- [ ] Compression
- [ ] Handlers
  - [x] Connect
  - [x] Keepalive
  - [ ] State

### Other
- [ ] State tracker (updated by HTTP calls and WebSocket events)
- [ ] Refactoring HTTP API functions
- [ ] Rate limiting on HTTP calls

## Future
This library won't hit 1.0 before Elixir 1.3 is released because `GenRouter` will replace `GenEvent`.

## Help
Should I be validating parameters or leave that up to users of this library? Did I write something in a stupid way? Anything else? Make an issue!

Pull requests welcome!
