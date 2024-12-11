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

    method seAnimaaSaquear(objetivo)=
        objetivo.puedeSerSaqueado(self)

    
    method noTieneMasDeMonedas(cantidad)=
    self.monedas() > cantidad

    method estaPasadoDeGrog()=
    90 <= self.ebriedad() && items.contains("botellaDeGrog")
    method tomarTratoGrog(ciudad){
        ebriedad += 5
        monedas= monedas- ciudad.precioEntrada()

    }
    method puedePagar(ciudad)= monedas >= ciudad.precioEntrada()



}
class PirataEspia inherits Pirata{
    override method estaPasadoDeGrog()= false

    override method seAnimaaSaquear(objetivo)= super(objetivo) && self.tiene("permisoDeLaCorona")

    

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
    method itemRaro()= self.itemsBarco().min({item=>self.cantidadDePiratasQueTienen(item)})

    method itemsBarco()= tripulantes.flatMap({tripulante=>tripulante.items()})

    method cantidadDePiratasQueTienen(item)= tripulantes.count({tripulante=>tripulante.tiene(item)})
    method anclarBarco(unaCiudad){
        self.tripulantesTomanGrog(unaCiudad)
        self.perderTripulanteMasEbrio(unaCiudad)
    }
    method tripulantesTomanGrog(unaCiudad){
        self.tripulantesQuePuedenPagar(unaCiudad).forEach{tripulante=>tripulante.tomarTratoGrog(unaCiudad)}

    }
    method perderTripulanteMasEbrio(unaCiudad){
        const elmasEbrio= self.tripulanteMasEbrio()
        tripulantes.remove(elmasEbrio)
        unaCiudad.aniadirTrip(elmasEbrio)


    }
    method tripulantesQuePuedenPagar(unaCiudad)= tripulantes.filter({tripulante=>tripulante.puedePagar(unaCiudad)})
    method tripulanteMasEbrio()= tripulantes.max({tripulante=>tripulante.ebriedad()})

}
class CiudadCostera{
    var cantidadHabitantes 
    var property precioEntrada
    method puedeSerSaqueado(saqueador)=
    50 <= saqueador.ebriedad()
    method esVulnerable(barcoAtacante)=
    barcoAtacante.tripulantes().size() <= cantidadHabitantes* 0.4 || barcoAtacante.tripiulantes().all({tripulante=>tripulante.estaPasadoDeGrog()})
    method aniadirTrip(unTripulante){
        cantidadHabitantes+=1

    }

}
/**********************************************************************************************************/
// LA HORDA 
class Personaje{
    const property fuerza = 0
    const property inteligencia 
    var rol  
    method potencial() = fuerza * 10 +  rol.extra()
    method esGroso()= self.esInteligente() || self.suRolEsGroso(self)
    method esInteligente()= false
    method suRolEsGroso(alguien)= rol.esGrosoo(alguien)
}
class Guerrero{
    var property extra = 100
    method esGrosoo(alguien)= alguien.fuerza() > 50

}
class Cazador{
    var mascota
    var property extra =mascota.potencialOfencivo()
    method esGrosoo(alguien)= mascota.esLongeva()


}
class Brujo{
   var property extra =  0 
   method esGrosoo()=true
}
// PERSONALES INSTANCIADOS
class Orco inherits Personaje{

    override method potencial()= super()* 1.1

}
class Humano inherits Personaje{
    override method esInteligente()= inteligencia > 50



}
class Mascota{
    var edad
    var fuerza
    method potencialOfencivo()
    method esLongeva()= edad> 10

}
class MarcotaConGarra inherits Mascota{
    override method potencialOfencivo()= fuerza *2
}
class MarcotaSinGarra inherits Mascota{
    override method potencialOfencivo()= fuerza
}


