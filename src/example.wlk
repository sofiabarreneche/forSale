object inmobiliaria{
	var empleados = #{}
	method mejorEmpleado(criterio){
		criterio.mejorEmpleado(empleados)
	}
}
class Inmueble{
	var tamanio
	var ambientes
	var operacion
	var tipoInmueble
	var property empleadoReservador
	var property estaReservada
	var property estado = disponible 
	
	method reservar() = estado.disponibilidad()
	method cambiarEstado(estadoNuevo){
		estado = estadoNuevo		
	}
	method empleadoConcretador(empleado){
		return empleado
	}
}
object operacionesReservadas{
	method mejorEmpleado(empleados){
		empleados.max({unEmpleado => unEmpleado.cantOperacionesReservadas()}) 
	}
}
object comisiones{
	method mejorEmpleado(empleados){
		empleados.max({unEmpleado => unEmpleado.comisionesTotales()})
	}
}
object operacionesTerminadas{
	method mejorEmpleado(empleados){
		empleados.max({unEmpleado => unEmpleado.cantOperacionesTerminadas()})
	}
}
object noDisponible{
	method disponibilidad(){
		return false
	}
}
object disponible{
	method disponibilidad(){
		return true
	}
}

class Alquiler inherits Inmueble{
	var cantMeses
	const property comision = cantMeses* valor /50000
	var valor
}
class Venta inherits Inmueble{
	var porcentaje
	var valor
	const property comision = porcentaje*valor
	
}
object galpon{
	var valorPropiedad
	method valor(){
		return valorPropiedad/2
	}
}
object localALaCalle{
	var montoFijo
	method valor(){
		return montoFijo
	}
}
object local inherits Casa{
	var tipo
	override method valor(){
		return tipo.valor()
	}
}
class Casa inherits Inmueble{
	var valorInmueble
	var zona 
	method valor(){
		return valorInmueble + zona.plus()
	}
}
object zona{
	var property plus
}
class Ph inherits Inmueble{
	var zona
	method valor(){
		return (14000*tamanio).max(500000) + zona
	} 
}
class Departamentos  inherits Inmueble{
	
	var zona
	method valor(){
		return 350000*ambientes + zona
	} 
}
class Cliente{
	method reservarPropiedadAlquiler(empleado,propiedad){
		empleado.reservar(propiedad)
	}
	method reservarPropiedadVenta(empleado,propiedad){
		if(propiedad.tipoInmueble() == local){
			self.error("no se puede vender")
		}else empleado.reservar(propiedad)
	}
}
class Empleado{
	var property cantOperacionesReservadas
	var property cantOperacionesTerminadas			
	var property comisionesTotales
	
	method reservar(propiedad){
		if(!self.estaReservadaLaPropiedad(propiedad)){
			self.hacerLaReserva(propiedad)
		}else self.error("ya esta reservada")
	}
	method estaReservadaLaPropiedad(propiedad) = propiedad.estaReservada()
	
	method hacerLaReserva(propiedad){
		propiedad.reservar()
		comisionesTotales += propiedad.comision()
		cantOperacionesReservadas += 1
		
	}
	method concretarOperacion(propiedad){
		cantOperacionesTerminadas += 1
		propiedad.cambiarEstado(noDisponible)
		propiedad.empleadoConcretador(self)
	}
	
	method problemasEntreEmpleados(propiedad,empleado) = 
		propiedad.empleadoReservador() != propiedad.empleadoConcretador(empleado)
		or propiedad.empleadoReservador() != propiedad.empleadoConcretador(self) 			//no se como evitar repeticion de codigo

}