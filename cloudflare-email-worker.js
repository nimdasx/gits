export default {
  async email(message, env, ctx) {
    const forwardList = [
      "x@xxxx", 
      "x@xxxxxxx"
    ];

    for (const email of forwardList) {
      try {
        await message.forward(email);
        console.log(`Sukses meneruskan ke: ${email}`);
      } catch (error) {
        // Jika ada error pada satu email, tangkap errornya dan lanjut ke email berikutnya
        console.error(`Gagal meneruskan ke ${email}: ${error.message}`);
      }
    }
  }
}