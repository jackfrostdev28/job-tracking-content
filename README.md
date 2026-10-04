# Hugcode Workboard

เว็บบอร์ดติดตามงานทีมภาษาไทย สร้างด้วย HTML, CSS และ JavaScript ฝั่ง client มีข้อมูลตัวอย่าง, responsive board, localStorage fallback และการเชื่อม Supabase Auth/PostgreSQL/Realtime แบบ optional

## เปิดใช้งานในเครื่อง

เปิด `index.html` ในเบราว์เซอร์ หรือเสิร์ฟโฟลเดอร์นี้ผ่านเว็บเซิร์ฟเวอร์ เช่น `npx serve .` ข้อมูลตัวอย่างจะพร้อมใช้งานและบันทึกใน localStorage ของเบราว์เซอร์

## ตั้งค่า Supabase

1. สร้าง Supabase project และเปิด Email provider ใน Authentication → Providers
2. คัดลอก URL และ publishable key (หรือ legacy anon key) จาก Project Settings → API
3. ใส่ค่าใน `supabase-config.js`:

   ```js
   window.HUGCODE_SUPABASE = {
     url: 'https://YOUR-PROJECT.supabase.co',
     anonKey: 'YOUR-PUBLISHABLE-OR-ANON-KEY',
     requireAuth: true
   };
   ```

   `requireAuth: true` บังคับให้ล็อกอินก่อนดูบอร์ด เมื่อไม่ระบุหรือเป็น `false` บอร์ดยังเปิดสาธารณะในแอป แต่การอ่าน/เขียนข้อมูล shared board ผ่าน RLS ต้องล็อกอินอยู่ดี
4. เปิด SQL Editor ใน Supabase แล้วรันไฟล์ `schema.sql` เพื่อสร้างตาราง `workboard_state`, RLS policies และเปิด Realtime
5. เพิ่มผู้ใช้ใน Authentication → Users หรือเปิด sign-up ตามนโยบายของทีม จากนั้นล็อกอินด้วยอีเมลและรหัสผ่าน
6. เสิร์ฟผ่าน `localhost` หรือ HTTPS เพื่อให้ Auth/session ทำงานได้เหมาะสม

ตารางมีแถวเดียว (`id = 1`) และเก็บ tasks, options, statuses เป็น JSONB เพื่อให้หลายคนเห็นบอร์ดเดียวกัน RLS ใน schema อนุญาตผู้ใช้ที่ยืนยันตัวตนทุกคนใน project อ่าน/เขียนร่วมกัน หากต้องจำกัดเฉพาะสมาชิกทีม ให้เปลี่ยน policies ให้ตรวจสอบตาราง membership ขององค์กร

หาก config ว่างหรือ Supabase ใช้งานไม่ได้ เว็บจะเปิดด้วยข้อมูล localStorage และแสดงสถานะการเชื่อมต่อ/คำแนะนำไว้บนหน้า ห้ามใส่ `service_role` key หรือ secret key ในไฟล์ client

## ความสามารถ

- เพิ่ม แก้ไข ลบ และเปิดรายละเอียดงาน พร้อมประวัติความคิดเห็น
- ลากการ์ดเพื่อเปลี่ยนสถานะ หรือใช้เมนูการ์ด
- ค้นหา กรองผู้รับผิดชอบ/วันที่มอบหมาย/กำหนดส่ง และล้างตัวกรอง
- ส่งออกเป็นไฟล์ CSV ที่ Excel เปิดได้ (`.xls`)
- จัดการรายการผู้รับผิดชอบ ผู้มอบหมาย โมดูล และสถานะ
- Layout 4 คอลัมน์บน desktop, 2 บน tablet และ 1 บนมือถือ

## Deploy ไป Vercel

1. Import โฟลเดอร์นี้เป็นโปรเจกต์ใน Vercel หรือใช้ `vercel deploy`
2. ตั้งค่า Supabase URL และ publishable/anon key ใน `supabase-config.js` ก่อน deploy (เป็น public client configuration)
3. เพิ่ม production domain ใน Supabase Authentication → URL Configuration → Site URL/Redirect URLs
4. ทดสอบล็อกอินและ Realtime บน production domain

ไม่ต้องใช้ build command หรือ framework; `index.html` เป็น entry point โดยตรง
