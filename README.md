# CI/CD Network Automation – MikroTik & Edge IoT

## Overvieww

PProject ini mengimplementasikan otomatisasi konfigurasi jaringan menggunakan pendekatan CI/CD.

Perubahan konfigurasi (IP & DHCP) divalidasi terlebih dahulu melalui pipeline CI sebelum dideploy ke router MikroTik melalui CD.

Tujuan utama:
- Mencegah kesalahan konfigurasi
- Mengurangi human error
- Membuat deployment konsisten dan terkontrol

---

## System Architecture

Komponen:

- **GitHub** → Source control
- **GitHub Actions** → CI/CD pipeline
- **Self-hosted Runner** → Eksekusi Ansible
- **MikroTik Router** → Target deployment
- **Edge IoT** → Client jaringan
- **Cloud Server** → Monitoring / MQTT

Flow:

Developer
↓
GitHub (Pull Request)
↓
CI Validation (GitHub Actions)
↓
Merge ke main
↓
CD Deployment
↓
MikroTik Router
↓
Edge IoT → Cloud Server



---

## CI (Validation Stage)

Trigger: Pull Request ke branch `main`

Tahapan:

- Ansible syntax check
- Validasi format IP address
- Validasi format DHCP pool
- Validasi gateway
- Dry-run deployment (`--check`)

Jika gagal:
- PR tidak bisa di-merge
- Deployment dibatalkan

---

## CD (Deployment Stage)

Trigger: Push / merge ke branch `main`

Tahapan:

- Runner terhubung ke MikroTik via SSH
- Update IP interface
- Update DHCP pool & network
- Enable DHCP server

Jika router tidak reachable:
- Deployment gagal
- Konfigurasi tidak diterapkan

---

## Repository Structure

ansible/
├── ansible.cfg
├── inventory.ini
├── group_vars/
│ └── mikrotik.yml
├── playbooks/
│ └── deploy.yml
├── roles/
│ ├── ip_address/
│ └── dhcp/
.github/workflows/
├── check.yml
└── deploy.yml


---

## Validation Rules

Deployment hanya dianggap valid jika:

- Format IP benar
- Format DHCP pool benar
- Gateway valid
- Tidak ada error pada playbook
- Router dapat dijangkau

---

## Branch Protection

Branch `main` dilindungi dengan aturan:

- Wajib Pull Request
- Wajib lulus CI
- Tidak bisa force push

Hal ini memastikan hanya konfigurasi yang tervalidasi yang dapat dideploy.

---

## Key Point

Project ini menunjukkan bahwa konsep CI/CD dapat diterapkan pada konfigurasi jaringan untuk meningkatkan:

- Reliability
- Consistency
- Automation
- Change control



