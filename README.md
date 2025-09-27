# Les 03 — Infra + Ansible

## Opdracht 1

### Terraform
- `cd terraform`
- `terraform init`
- `terraform apply -auto-approve`
Daarna staat de VM klaar en wordt automatisch een [inventory.ini](inventory.ini) gemaakt voor Ansible.

### Ansible-test verbinding
  ```bash
  ansible -i inventory.ini all -m ping
````

## Opdracht 2
```
mkdir -p outputs
ansible-playbook -i inventory.ini playbooks/02_variables.yml | tee outputs/opdracht2-run1.txt
ansible-playbook -i inventory.ini playbooks/02_variables.yml | tee outputs/opdracht2-run2.txt
```
### Extra bewijs (inhoud wegschrijven)
```
ansible -i inventory.ini all -a "cat /etc/motd"       | tee outputs/opdracht2-motd.txt
ansible -i inventory.ini all -a "cat /tmp/facts.txt"  | tee outputs/opdracht2-facts.txt
ansible -i inventory.ini all -a "cat /tmp/kernel.txt" | tee outputs/opdracht2-kernel.txt
```
 
Run 1: [opdracht2-run1.txt](outputs/opdracht2-run1.txt)

Run 2: [opdracht2-run1.txt](outputs/opdracht2-run1.txt) 

MOTD: [opdracht2-motd.txt](outputs/opdracht2-motd.txt) 

Facts: [opdracht2-facts.txt](outputs/opdracht2-facts.txt)

Kernel: [opdracht2-kernel.txt](outputs/opdracht2-kernel.txt)

## Opdracht 3 – Voorwaardelijke taken

In deze opdracht heb ik een playbook gemaakt [03_conditionals.yml](playbooks/03_conditionals.yml) dat afhankelijk van de distributie andere taken uitvoert.

- Als de server **Ubuntu** is, wordt een bericht getoond en wordt een testbestand gemaakt.
- Als de server **Red Hat** zou zijn, wordt een ander bericht getoond.
- Er wordt gecontroleerd of `/etc/hosts` bestaat. De taak kan falen als het bestand er niet is.
- Er is ook een taak die `echo hallo` uitvoert maar **niet** als “changed” wordt gezien.

### Resultaat
- Eerste run: er wordt een testbestand gemaakt en je ziet `changed=1`. Zie [opdracht3-run1.txt](outputs/opdracht3-run1.txt).
- Tweede run: alles is al gedaan, er verandert niks meer en je ziet `changed=0`. Zie [opdracht3-run2.txt](outputs/opdracht3-run2.txt).

## Opdracht 4 — Includes, Imports & Roles

In deze opdracht heb ik laten zien hoe je Ansible-taken kunt opsplitsen en hergebruiken.

### Wat ik heb gedaan
- **Nieuwe branch:** `tasks` gemaakt voor deze opdracht.
- **Imports & includes:**  
  - In [`site.yaml`](site.yaml) gebruik ik [`import_tasks`](playbooks/04_imports_includes/import_example.yml) om taken in te laden bij het starten van het playbook.  
  - Ik gebruik ook [`include_tasks`](playbooks/04_imports_includes/include_example.yml) om dynamisch taken toe te voegen tijdens runtime.  
- **Role:**  
  - De role [`role_firewall`](roles/role_firewall/tasks/main.yml) aangemaakt.  
  - Deze installeert **UFW**, zet de **policy op allow**, en opent **poort 8080**.  
  - UFW wordt daarna geactiveerd.
- **Playbook:** [`site.yaml`](site.yaml) voert de imports, includes en de firewall-role uit op de VM.

### Verschil `import_tasks` en `include_tasks`
- [`import_tasks`](playbooks/04_imports_includes/import_example.yml): wordt al bij het inladen van het playbook verwerkt. Taken zijn dus vooraf bekend en zichtbaar in de “task list”.
- [`include_tasks`](playbooks/04_imports_includes/include_example.yml): wordt pas tijdens runtime geladen. Handig als je taken alleen soms wilt draaien (bijv. met `when`-condities of variabelen).

### Waarom roles handig zijn
- Scheiden van logica per onderdeel (firewall, webserver, database, etc.).
- Code herbruikbaar en overzichtelijk.
- Makkelijk om later uit te breiden of met Ansible Galaxy te delen.

### Test
- Playbook gedraaid met:
  ```bash
  ansible-playbook -i inventory.ini site.yaml | tee outputs/opdracht4-run1.txt
- Daarna in de VM gecontroleerd:
  ```
  sudo ufw status
  ```
Output liet zien dat poort 8080 open is en de policy op allow staat.

 