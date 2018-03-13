import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

passwordHashingKeyDerivation() async {
  // https://download.libsodium.org/doc/password_hashing/the_argon2i_function.html
  printHeader('Password hashing key derivation');
  try {
    final password = UTF8.encode('Correct Horse Battery Staple');
    final salt = await Sodium.randombytesBuf(crypto_pwhash_SALTBYTES);
    final hash = await Sodium.cryptoPwhash(
        crypto_box_SEEDBYTES,
        password,
        salt,
        crypto_pwhash_OPSLIMIT_INTERACTIVE,
        crypto_pwhash_MEMLIMIT_INTERACTIVE,
        crypto_pwhash_ALG_DEFAULT);

    print('pwhash: ${hex.encode(hash)}');
  } catch (e) {
    print(e);
  }
}

passwordHashingStorage() async {
  // https://download.libsodium.org/doc/password_hashing/the_argon2i_function.html
  printHeader('Password hashing storage');

  try {
    const opslimit = crypto_pwhash_OPSLIMIT_INTERACTIVE;
    const memlimit = crypto_pwhash_MEMLIMIT_INTERACTIVE;
    final password = UTF8.encode('Correct Horse Battery Staple');
    final str = await Sodium.cryptoPwhashStr(password, opslimit, memlimit);
    final valid = await Sodium.cryptoPwhashStrVerify(str, password);

    // needsRehash not implemented for Android
    // final needsRehash =
    //     await Sodium.cryptoPwhashStrNeedsRehash(str, opslimit, memlimit);
    print(ascii.decode(str));

    assert(valid);
    //assert(!needsRehash);
  } catch (e) {
    print(e);
  }
}

secretKeyAuthentication() async {
  // https://download.libsodium.org/doc/secret-key_cryptography/secret-key_authentication.html
  printHeader('Secret key authentication');

  try {
    final message = UTF8.encode('test');
    final key = await Sodium.cryptoAuthKeygen();
    final mac = await Sodium.cryptoAuth(message, key);

    print('mac: ${hex.encode(mac)}');

    final isValid = await Sodium.cryptoAuthVerify(mac, message, key);

    assert(isValid);
  } catch (e) {
    print(e);
  }
}

shortInputHashing() async {
  // https://download.libsodium.org/doc/hashing/short-input_hashing.html

  printHeader('Short input hashing');
  try {
    final data = UTF8.encode('Sparkling water');
    final key = await Sodium.cryptoShorthashKeygen();
    final hash = await Sodium.cryptoShorthash(data, key);

    print('shorthash: ${hex.encode(hash)}');
  } catch (e) {
    print(e);
  }
}

generatingRandomData() async {
  // https://download.libsodium.org/doc/generating_random_data/

  printHeader('Generating random data');
  try {
    final rnd = await Sodium.randombytesRandom();
    final rndUniform = await Sodium.randombytesUniform(100);
    final rndBuf = await Sodium.randombytesBuf(16);

    print('random: $rnd');
    print('random uniform: $rndUniform');
    print('random buffer: ${hex.encode(rndBuf)}');
  } catch (e) {
    print(e);
  }
}

printHeader(String value) {
  print('--\n$value');
}