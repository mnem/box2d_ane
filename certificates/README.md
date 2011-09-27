Certificates
============

Here's the place for the signing certificate. Add it to this folder and call
it 'certificate.p12'. It is ignored by the .gitignore file (you really do
NOT want to check in your certificate publically), but it is used by the
Rakefiles to sign both the extension and the AIR test application.

Also, if you want to be incredibly insecure, you can add a file called
'.password' to the certificates folder and this will automagically be
passed as the password to the signing tools. **THIS IS VERY BAD AND VERY LAZY.**
You are much safer just entering it when prompted.
