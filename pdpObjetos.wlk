class  Mision {
   method esUtil(pirata)
   method puedeSerRealizadaPor(barco)
  
}
object busquedaTesoro inherits Mision {
    override method esUtil(pirata)= 
    pirata.noTieneMasDeMonedas(5) && pirata.tiene(brujula) || pirata.tiene(mapa ) || pirata.tiene( botelladegrogXD )

    override method puedeSerRealizadaPor(barco)=
    barco.tieneSuficienteTrip() && barco.tripulantes().any({tripulante=>tripulante.tiene("llaveDeCofre")})
  
}
object convertiseLeyenda inherits Mision{
    var itemObligatorio

    override method esUtil(pirata)= 
        10 < pirata.cantidadItems() && pirata.tiene(itemObligatorio)

    override method puedeSerRealizadaPor(barco)= barco.tieneSuficienteTrip() 
}
object saqueos inherits Mision{
    
    const property objetivoSaqueo

    override method esUtil(pirata)=
     objetoModedas.cantidadMonedas() > pirata.monedas() && pirata.seAnimaaSaquear(objetivoSaqueo)

    override method puedeSerRealizadaPor(barco)=
    barco.tieneSuficienteTrip() && objetivoSaqueo.esVulnerable(barco)
}
object objetoModedas{
    var property cantidadMonedas = 0
}
class Pirata {
    var property items=[]
    var property monedas
    var property ebriedad 

    method tiene(item)=
    items.contains(item)

    method cantidadItems()=
    items.size()

    method seAnimaaSaquear(objetivo){
        objetivo.puedeSerSaqueado(self)

    }
    method noTieneMasDeMonedas(cantidad)=
    self.monedas() > cantidad

    method estaPasadoDeGrog()=
    90 <= self.ebriedad() && items.contains("botellaDeGrog")



}
class BarcoPirata {
    const property capacidad
    var property mision 
    var tripulantes =[] 
    method puedeSerSaqueado(saqueador)=
    saqueador.estaPasadoDeGrog()
    method puedeFormarparte(pirata)=
    tripulantes.size() < capacidad && mision.esUtil(pirata)
    method aniadirIntegrante(pirata){
        if(self.puedeFormarparte(pirata))
        tripulantes.add(pirata)
        else
        self.error("NO SE PUDO SUBIR EL COMPA :(")
    }
    method mision(nuevaMision) {
        mision=nuevaMision
        tripulantes= tripulantes.filter({tripulante=>nuevaMision.esUtil(tripulante)}) 
      
    }
    method esTemible()=
    self.puedeRealizarMision() && 5 <= self.cantidadTripulanteaUtilies()
    method puedeRealizarMision()= mision.puedeSerRealizadaPor(self) 
    method cantidadTripulanteaUtilies() = (tripulantes.filter({tripulante=>mision.esUtil(tripulante)})).size()
    method tieneSuficienteTrip()=
    tripulantes.size() >= capacidad * 0.9 
    method esVulnerable(barcoAtacante)=
    self.cantidadDeTripulantes() <= (barcoAtacante.cantidadDeTripulantes()) / 2

    method cantidadDeTripulantes() = tripulantes.size()
    method itemRaro()=
}
class CiudadCostera{
    var cantidadHabitantes 
    method puedeSerSaqueado(saqueador)=
    50 <= saqueador.ebriedad()
    method esVulnerable(barcoAtacante)=
    barcoAtacante.tripulantes().size() <= cantidadHabitantes* 0.4 || barcoAtacante.tripiulantes().all({tripulante=>tripulante.estaPasadoDeGrog()})

}
