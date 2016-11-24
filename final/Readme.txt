De m2s file kan gewoon gerund worden met de standaard Adder16b.
Om niet enkel het pad naar s15, maar ook de andere paden te testen, is er DDIS1_extensiveTest. In die map runt de file 'sweepCP.m' tests op alle paden die in dat bestand aangegeven worden (de 'pathIndexArray' variabele). In de m2s file wordt voor ieder pad de .vec file ingelezen die met dat pad overeenkomt.

Er zijn verschillende test-scenarios:
Voor max speed:
- in m2s file: zet pMOSscalar op 1.6. 
- In sweepCP (of adder16b), zet Supply op 1V.

Voor min EDP:
- in m2s file: zet pMOSscalar op 1.0
- zet Supply op 1V

Voor min power @ 650ps:
- in m2s file: zet pMOSscalar op 1.0
- zet Supply op 0.933V
